Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58139 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab2BVXsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 18:48:18 -0500
Received: by iacb35 with SMTP id b35so706928iac.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2012 15:48:18 -0800 (PST)
Message-ID: <4F457EBF.6010203@lwfinger.net> (sfid-20120223_004822_310704_3D4771AC)
Date: Wed, 22 Feb 2012 17:48:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>
Subject: Re: Instability in brcmsmac
References: <4F416159.9000305@lwfinger.net> <4F451459.2050807@broadcom.com>
In-Reply-To: <4F451459.2050807@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/22/2012 10:14 AM, Arend van Spriel wrote:
>
> I tried reproducing this, but not luck so far. Could you provide me with syslog
> including both kernel messages and wpa_supplicant. From the log you provided it
> seems mac80211 triggers the disassoc. It could be a beacon timeout, but I would
> like to be sure. More debug output from mac80211 itself would also be helpful to
> understand the issue.

I may have misunderstood the symptoms with my system. The only AP that is 
connected automatically is 802.11n; however, many of my cards now refuse to 
connect to that AP. The BCM43224 is one of them. As a result, when the 
connection to an 802.11g AP failed, the reconnection was to the N router, and it 
failed.

I need to determine what is causing the failure to connect to the N router. It 
might be a regression. After I find and fix that problem, then I can retest the 
BCM43224.

Thanks, and sorry for the noise,

Larry

