Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2023 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab2HFTTm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:19:42 -0400
Message-ID: <502018B6.2070005@broadcom.com> (sfid-20120806_211945_874894_E988CA83)
Date: Mon, 6 Aug 2012 21:19:18 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jeff Mahoney" <jeffm@suse.com>
cc: linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>
Subject: Re: [PATCH] brcmsmac: document firmware dependencies
References: <50201846.2000606@suse.com>
In-Reply-To: <50201846.2000606@suse.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2012 09:17 PM, Jeff Mahoney wrote:
> The brcmsmac driver requests firmware but doesn't document the
> dependency. This means that software that analyzes the modules to
> determine if firmware is needed won't detect it.
> 
> Specifically, (at least) openSUSE won't install the kernel-firmware
> package if no hardware requires it.
> 
> This patch adds the MODULE_FIRMWARE directives.
>

Acked-by: Arend van Spriel <arend@broadcom.com>

> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Gr. AvS

