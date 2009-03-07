Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:8347 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZCGDFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 22:05:33 -0500
Received: by wf-out-1314.google.com with SMTP id 28so871153wfa.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 19:05:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890903061409h1cc9f1a2r501fd44a05b8c786@mail.gmail.com>
References: <1236316387-9718-1-git-send-email-lrodriguez@atheros.com>
	 <1236316387-9718-2-git-send-email-lrodriguez@atheros.com>
	 <43e72e890903061409h1cc9f1a2r501fd44a05b8c786@mail.gmail.com>
Date: Fri, 6 Mar 2009 19:05:30 -0800
Message-ID: <43e72e890903061905g6a2bff1bld0232e05409643b9@mail.gmail.com> (sfid-20090307_040542_856100_A2F9C684)
Subject: Re: [PATCH 2/2] mac80211_hwsim: add regulatory_hint support
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: j@w1.fi, linville@tuxdriver.com
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 6, 2009 at 2:09 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Mar 5, 2009 at 9:13 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> ACME Inc. only sells these in Finland.
>
> On second thought this is not such a good idea as simply loading it
> would change your regulatory domain which is not the desired effect
> for testing purposes. I will resend with some other things to avoid
> undesired regulatory changes.

I see this was merged already - its ok, I'll just send a patch on top.

  Luis
