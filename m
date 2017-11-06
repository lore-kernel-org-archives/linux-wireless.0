Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9038 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750724AbdKFAAh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Nov 2017 19:00:37 -0500
Date: Mon, 6 Nov 2017 01:00:32 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        r.baldyga@samsung.com, k.opasiak@samsung.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] constify nfc i2c_device_id
Message-ID: <20171106000032.GB27831@zurbaran.ger.intel.com> (sfid-20171106_010052_083404_98BD241C)
References: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arvind,

On Mon, Aug 21, 2017 at 10:33:52PM +0530, Arvind Yadav wrote:
> i2c_device_id are not supposed to change at runtime. All functions
> working with i2c_device_id provided by <linux/i2c.h> work with
> const i2c_device_id. So mark the non-const structs as const.
> 
> Arvind Yadav (8):
>   [PATCH 1/8] nfc: microread: constify i2c_device_id
>   [PATCH 2/8] nfc: nfcmrvl: constify i2c_device_id
>   [PATCH 3/8] nfc: nxp-nci: constify i2c_device_id
>   [PATCH 4/8] nfc: pn533: constify i2c_device_id
>   [PATCH 5/8] nfc: pn544: constify i2c_device_id
>   [PATCH 6/8] nfc: s3fwrn5: constify i2c_device_id
>   [PATCH 7/8] nfc: st-nci: constify i2c_device_id
>   [PATCH 8/8] nfc: st21nfca: constify i2c_device_id
All 8 patches applied, thanks.

Cheers,
Samuel.
