Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4821 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1AYWHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 17:07:36 -0500
From: "Brett Rudley" <brudley@broadcom.com>
To: "Richard Riley" <rileyrg@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 25 Jan 2011 14:07:18 -0800
Subject: RE: bcm4313/bcrm80211 and debian liquirix
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE13CD6E92B2@SJEXCHCCR01.corp.ad.broadcom.com>
References: <vnbp34slhy.fsf@news.eternal-september.org>
In-Reply-To: <vnbp34slhy.fsf@news.eternal-september.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes it should.  This issue recently appeared and I believe a patch has already been submitted.

The fix is to simply delete that offending line. (It was a bogus check in the first place).

Thanks
Brett

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Richard Riley
> Sent: Tuesday, January 25, 2011 1:48 PM
> To: linux-wireless@vger.kernel.org
> Subject: bcm4313/bcrm80211 and debian liquirix
> 
> 
> According to docs I googled up the brcm80211 driver should work with the
> bcm4313 wireless device.
> 
> I have installed the debian firmware-brcm80211 package but when I
> modprobe the bcrm80211 module there is kernel panic, I get the black
> screen of death and a dump saying  (reading off the
> laptop screen)
> 
> !(sdu->cloned) failed : file wlc_mac80211.c line 5140
> 
> 
> I'm fairly new to all this so any pointers greatfully received. My
> kernel is:-
> 
> Linux asus1015pem 2.6.37-0.slh.7-aptosid-686 #1 SMP PREEMPT Sun Jan 16
> 23:16:55 UTC 2011 i686 GNU/Linux
> 
> 
> If I can provide more info please let me know and let me know how.
> 
> regards
> 
> r.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


