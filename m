Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2070 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab2BVQPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 11:15:37 -0500
Message-ID: <4F451459.2050807@broadcom.com> (sfid-20120222_171616_585564_9964B708)
Date: Wed, 22 Feb 2012 17:14:17 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: wireless <linux-wireless@vger.kernel.org>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>
Subject: Re: Instability in brcmsmac
References: <4F416159.9000305@lwfinger.net>
In-Reply-To: <4F416159.9000305@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2012 09:53 PM, Larry Finger wrote:
> Arend,
>
> I have just started testing brcmsmac with my BCM43224 card. I find it rather
> unstable. A typical cycle between authentication and disassociating is as follows:
>
> The period of time that the interface is up ranges from 10 - 200 seconds. The
> connection is WPA-TKIP and the kernel is master-2012-02-15-510-g20b79b4 from
> wireless-testing with local patches applied to other drivers. Both brcmsmac and
> bcma are untouched.
>

Hi Larry,

I tried reproducing this, but not luck so far. Could you provide me with 
syslog including both kernel messages and wpa_supplicant. From the log 
you provided it seems mac80211 triggers the disassoc. It could be a 
beacon timeout, but I would like to be sure. More debug output from 
mac80211 itself would also be helpful to understand the issue.

Gr. AvS

