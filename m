Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3290 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab1HHQ2t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 12:28:49 -0400
Message-ID: <4E400EB6.5000508@broadcom.com> (sfid-20110808_182852_360017_48158171)
Date: Mon, 8 Aug 2011 18:28:38 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "gregkh@suse.de" <gregkh@suse.de>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 01/82] staging: brcm80211: fix compile error on
 non-x86 archs since 3.0 kernel
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
 <1312811946-16713-2-git-send-email-arend@broadcom.com>
In-Reply-To: <1312811946-16713-2-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2011 03:57 PM, Arend van Spriel wrote:
> From: Arend Van Spriel<arend@broadcom.com>
>
> Since the arrival of kernel version 3.0 in the staging tree it
> turns out compile error occurs for sparc64, powerpc, and arm
> platforms. This patch fixes that issue.
>

Hi Greg,

Actually, the error was also on MIPS which is enabled in Kconfig. Can 
this one also go to 3.1 ie. Linus' tree?

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


