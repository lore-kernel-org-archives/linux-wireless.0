Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52885 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2CGH6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 02:58:55 -0500
Received: by wejx9 with SMTP id x9so3578901wej.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 23:58:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG9cJm=0hULCgfCp4p6WCdr3kKrZUBMebOiVBVfd0sCoNK=PCA@mail.gmail.com>
References: <CAG9cJm=0hULCgfCp4p6WCdr3kKrZUBMebOiVBVfd0sCoNK=PCA@mail.gmail.com>
Date: Wed, 7 Mar 2012 08:58:54 +0100
Message-ID: <CACna6rwraGgRW=_Htp=NOJNDNZVj9kzR28kYOV2ZBtVq_a7XyQ@mail.gmail.com> (sfid-20120307_085859_110606_AF4716C8)
Subject: Re: PMU resource config unknown for device 0x4331
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: lina <lina.lastname@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/2/23 lina <lina.lastname@gmail.com>:
> How to understand
>
> PMU resource config unknown for device 0x4331
>
> Thanks with best regards,

The driver didn't know what to do in case of 0x4331. I think we don't
need any PMU resoruce configuration for BCM4331, so this warning is
harmless.

-- 
Rafał
