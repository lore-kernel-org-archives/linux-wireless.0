Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr8.hinet.net ([168.95.4.108]:63672 "EHLO msr8.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab1GCBto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jul 2011 21:49:44 -0400
Date: Sun, 3 Jul 2011 09:47:54 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
Message-ID: <20110703014754.GA4080@internetdog.org> (sfid-20110703_034947_366576_72FDB221)
Reply-To: ali@internetdog.org
References: <20110621124954.GA8462@internetdog.org>
 <4E011644.3070906@lwfinger.net>
 <20110622010057.GA12123@internetdog.org>
 <4E0154B7.2000204@lwfinger.net>
 <20110622025623.GC12547@internetdog.org>
 <4E015CE8.3000304@lwfinger.net>
 <20110627072351.GA4251@internetdog.org>
 <4E0F50B4.3080805@lwfinger.net>
 <20110703010605.GA3736@internetdog.org>
 <4E0FC4B1.7080909@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E0FC4B1.7080909@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 02, 2011 at 08:24:01PM -0500, Larry Finger wrote:
> On 07/02/2011 08:06 PM, Ali Bahar wrote:

> >device. I dug into it because there seemed to be a need within this
> >ML (and I was already looking for an 802.11 project anyway.)

> >>  	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
> >>  		return -1;
> >>  	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))
> 
> If you want to work on it, I will review and test the patches. It

OK.

> will be a long time until I get to it.

I understand.

later,
ali
