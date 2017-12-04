Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0113.outbound.protection.outlook.com ([104.47.38.113]:10636
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752977AbdLDD42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Dec 2017 22:56:28 -0500
Reply-To: chi-hsien.lin@cypress.com
Subject: Re: [PATCH V2] brcm: add CYW4373 firmwares and Cypress license file
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com
References: <20171201084243.GA58942@aremote07.aus.cypress.com>
 <f96ddf93-0e1d-d6f1-570b-fd3c8ec711e0@broadcom.com>
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Message-ID: <b28125eb-c251-405b-c955-f87a0d7c6b25@cypress.com> (sfid-20171204_045640_435036_17CDD715)
Date: Mon, 4 Dec 2017 11:56:20 +0800
MIME-Version: 1.0
In-Reply-To: <f96ddf93-0e1d-d6f1-570b-fd3c8ec711e0@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/02/2017 3:57, Arend van Spriel wrote:
> On 01-12-17 09:43, Chi-Hsien Lin wrote:
>> Add the CYW4373 SDIO and USB firmware files, along with the corresponding
>> Cypress license file.
> 
> Just wanted to be sure. These firmware files contain a CLM to get the 
> device operational, ie. no separate CLM download is needed.
> 
Arend,

These files do not have CLM info built-in, so a clm_blob file is 
expected to be delivered separately like nvram file.

Regards,
Chi-hsien Lin
