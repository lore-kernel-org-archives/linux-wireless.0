Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:58686 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbZCZBfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 21:35:14 -0400
Received: by wf-out-1314.google.com with SMTP id 29so365513wff.4
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 18:35:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890903251821i7b582601r877662790ceb747c@mail.gmail.com>
References: <20090323162834.154525349@sipsolutions.net> <20090323163051.784425387@sipsolutions.net>
	<43e72e890903251821i7b582601r877662790ceb747c@mail.gmail.com>
Date: Wed, 25 Mar 2009 18:34:58 -0700
Message-ID: <43e72e890903251834i5e78bb7p3c96f2f5537f955c@mail.gmail.com> (sfid-20090326_023517_783011_E822134F)
Subject: Re: [PATCH 1/8] mac80211: rewrite fragmentation
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 6:21 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> I see only one possible regression with this patch and that is that it
> seems you forgot to update the mdev->trans_start in the new loop on
> each fragment.
>
> As far as I can tell this would only introduce a regression with if
> someone is using a netdev watchdog on the mdev, if we don't care about
> that and I'm not missing any other case where this could be affected
> we might as well remove that first update as at least for mac80211 its
> completely untouched.
>
> Other than that:
>
> Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Above is my actual reply, seems gmail stored it properly... hmm.......

  Luis
