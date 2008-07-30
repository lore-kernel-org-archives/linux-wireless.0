Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:32061 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbYG3BGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 21:06:09 -0400
Received: by wf-out-1314.google.com with SMTP id 27so197111wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 18:06:08 -0700 (PDT)
Message-ID: <3ace41890807291806h6e72ad2ub11d89d910831ae9@mail.gmail.com> (sfid-20080730_030614_260430_C373D826)
Date: Wed, 30 Jul 2008 02:06:08 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: mac80211 power management breakage?(was Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187)
Cc: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>,
	"Samuel Ortiz" <sameo@openedhand.com>
In-Reply-To: <874p69m3gq.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <3ace41890807260626x925b6b8h90f85dd91b24b4d5@mail.gmail.com>
	 <874p69m3gq.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 10:42 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
<snipped>
> Do you mean this patch from Samuel which is in wireless-testing:
>
> commit 8f87dd7e540d455f8e7f11478133b85edc969c67
> Author: Samuel Ortiz <samuel@sortiz.org>
> Date:   Fri Jul 4 10:49:31 2008 +0200
>
>    mac80211: power management wext hooks

Yes.

<snipped>
> You are confusing AP and client mode PSM here,
> MAC80211_VERBOSE_PS_DEBUG is used for debugging PSM support in AP
> mode. Client mode PSM support is usually implemented in the driver or
> the firmware. We are planning to add some PSM support to mac80211, but
> it's still in the works.

Yes, I realised I was talking rubbish :-). But as you said, enabling
PS should have no effect whatsoever.
The other possibility is IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING, but that
also seems to be AP mode -specific.
