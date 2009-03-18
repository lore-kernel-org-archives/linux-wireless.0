Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:25853 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZCRARt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 20:17:49 -0400
Received: by yx-out-2324.google.com with SMTP id 31so250420yxl.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 17:17:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C02543.4040204@hauke-m.de>
References: <49C020F9.9080301@hauke-m.de> <49C02543.4040204@hauke-m.de>
Date: Tue, 17 Mar 2009 17:17:47 -0700
Message-ID: <43e72e890903171717t688587bax38b1bf6ad55fd237@mail.gmail.com> (sfid-20090318_011752_908148_33972503)
Subject: Re: [compat] Add MWL8K support
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 17, 2009 at 3:33 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Add support for Marvell 88W8xxx PCI/PCIe Wireless to compat-wireless.
> Without this patch it has to be deactivated in
> drivers/net/wireless/Makefile.

Applied all 5 patches, thanks so much.

  Luis
