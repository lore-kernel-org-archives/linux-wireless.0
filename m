Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:40211 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZFKMrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 08:47:41 -0400
Received: by gxk10 with SMTP id 10so2206177gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 05:47:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890906101721i3e45b9fev40892e6babe5fc6e@mail.gmail.com>
References: <1244664108-3997-1-git-send-email-hauke@hauke-m.de>
	<1244664108-3997-3-git-send-email-hauke@hauke-m.de> <43e72e890906101721i3e45b9fev40892e6babe5fc6e@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 11 Jun 2009 22:41:36 +1000
Message-ID: <646765f40906110541p355be465gc3750c6509fa47ef@mail.gmail.com>
Subject: Re: [PATCH 3/3] [compat-2.6] Backport rfkill for kernel older than
	2.6.31.
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2009 at 10:21, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> On Wed, Jun 10, 2009 at 1:01 PM, Hauke Mehrtens<hauke@hauke-m.de> wrote:
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>
> Thank you!!!!! New tarball generated with all the latest updates and yours.
>
> wireless-testing latest tag:
> master-2009-06-10
> This is compat-release:
> master-2009-06-10

FWIW, this builds fine on my Debian 2.6.29 amd64 system, and the
rt2500pci driver works perfectly.

Thanks!

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
