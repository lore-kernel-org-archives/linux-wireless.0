Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab3EMRS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 13:18:26 -0400
Message-ID: <1368465499.8300.33.camel@jlt4.sipsolutions.net> (sfid-20130513_191829_585411_F0B804F8)
Subject: Re: [PATCH 2/3] cfg80211: Allow ieee80211g mandatory rate sets in
 2.4GHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org
Date: Mon, 13 May 2013 19:18:19 +0200
In-Reply-To: <CACcxo+odk2L-pymHqof+geeEmKcC4xikebra9jcNZoHOF0by4A@mail.gmail.com> (sfid-20130513_191326_968050_5F083BC5)
References: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
	 <1368233453-10581-2-git-send-email-ashok@cozybit.com>
	 <1368438160.8300.11.camel@jlt4.sipsolutions.net>
	 <CACcxo+odk2L-pymHqof+geeEmKcC4xikebra9jcNZoHOF0by4A@mail.gmail.com>
	 (sfid-20130513_191326_968050_5F083BC5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-13 at 10:13 -0700, Ashok Nagarajan wrote:
> On Mon, May 13, 2013 at 2:42 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2013-05-10 at 17:50 -0700, Ashok Nagarajan wrote:
> >> This patch assumes 11g support
> >> implies a 11g operation and returns the appropriate mandatory rates.
> >
> > Which is a problem, because it means that by default we'll create IBSS
> > networks that are not compatible with 11b devices.
> 
> Okay make sense. I would drop just this patch and send rest.

If you just want the others as is I can do that, no need to resend. Let
me know.

johannes

