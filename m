Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:43768 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHWO6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 10:58:45 -0400
Received: by mail-ob0-f181.google.com with SMTP id va2so9522604obc.12
        for <linux-wireless@vger.kernel.org>; Sat, 23 Aug 2014 07:58:44 -0700 (PDT)
Message-ID: <53F8AA88.4070907@lwfinger.net> (sfid-20140823_165849_032107_A5221BB4)
Date: Sat, 23 Aug 2014 09:51:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] bcma: add PCI ID for spromless BCM43227
References: <1408789351-5803-1-git-send-email-hauke@hauke-m.de> <CACna6ry5Nw6Z5fugawwELzv=EPBB1jKGRFSa6GrETU5gGtCCaw@mail.gmail.com>
In-Reply-To: <CACna6ry5Nw6Z5fugawwELzv=EPBB1jKGRFSa6GrETU5gGtCCaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2014 08:39 AM, Rafał Miłecki wrote:
> On 23 August 2014 12:22, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> This adds the PCI ID a BCM43227 without a sprom.
> 
> Do you have bcma log from detecting this chip? Is this really BCM43227?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

When you resubmit, could you also add the Product ID in hex in a comment? If it
were ever necessary to find the driver from the PCI ID given by 'lspci -nn',
having that ID in the code would be useful.

Larry


