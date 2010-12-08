Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f177.google.com ([209.85.216.177]:57878 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LHWOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 17:14:08 -0500
Received: by qyk27 with SMTP id 27so1082189qyk.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 14:14:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101208205000.GA30861@broadcom.com>
References: <4CBE23F4.4020104@broadcom.com>
	<20101019233520.GA12510@kroah.com>
	<FD96C117992C584DBC47231B1EB6F5568206D859DC@SJEXCHCCR02.corp.ad.broadcom.com>
	<20101020004743.GB31965@kroah.com>
	<20101020005546.GL10832@broadcom.com>
	<20101020010320.GA370@kroah.com>
	<20101021170810.GA15357@broadcom.com>
	<1288621739.26983.32.camel@macbook.infradead.org>
	<20101208205000.GA30861@broadcom.com>
Date: Wed, 8 Dec 2010 23:07:53 +0100
Message-ID: <AANLkTin70oBFYq8LMJYw6zc7oVF9-UXv=nn_ophx+L2S@mail.gmail.com>
Subject: Re: [PATCH v2] linux-firmware: brcm: Removed codeversion from
 firmware filenames.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Brett Rudley <brudley@broadcom.com>,
	"grundler@google.com" <grundler@google.com>,
	"greg@kroah.com" <greg@kroah.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rvossen@broadcom.com, dowan@broadcom.com, arend@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/8 Henry Ptasinski <henryp@broadcom.com>:
> Second attempt at cleaning up firmware filenames.
>
> The basename-apiversion-codeversion construction for firmware filenames is not
> used by most other firmware files, adds complexity, and is not providing any
> value.  Renamed the firmware files using just basename-apiversion.  Also, fixed
> WHENCE to have correct path to brcmfmac files.
>
> Signed-off-by: Henry Ptasinski <henryp@broadcom.com>

Henry, I believe we got report that Red Hat can not include your
firmware anyway because of licensing. Can you change license to some
common one which allows providing your firmware with distributions?

-- 
Rafał
