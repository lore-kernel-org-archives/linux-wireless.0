Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3697 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab2EHSFi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 14:05:38 -0400
Message-ID: <4FA9606E.6000505@broadcom.com> (sfid-20120508_200541_972879_E5410195)
Date: Tue, 8 May 2012 11:05:34 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Il Han" <corone.il.han@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcm80211: Remove an unused variable.
References: <1336458947-20698-1-git-send-email-corone.il.han@gmail.com>
In-Reply-To: <1336458947-20698-1-git-send-email-corone.il.han@gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2012 11:35 PM, Il Han wrote:
> The variable val is not used afterward.
> Remove the declaration and the assignment line of it.
>
> Signed-off-by: Il Han<corone.il.han@gmail.com>
> ---

Thanks Il. Add John as recipient as well.

Acked-by: Franky Lin <frankyl@broadcom.com>

Regards,
Franky

