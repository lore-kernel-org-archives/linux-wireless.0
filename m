Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 0.mx.nanl.de ([217.115.11.12]:42092 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399AbaCDUIx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 15:08:53 -0500
Received: from mail-qg0-f42.google.com (mail-qg0-f42.google.com [209.85.192.42])
	by mail.nanl.de (Postfix) with ESMTPSA id 8DE9B460BD
	for <linux-wireless@vger.kernel.org>; Tue,  4 Mar 2014 20:08:38 +0000 (UTC)
Received: by mail-qg0-f42.google.com with SMTP id q107so93092qgd.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 12:08:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140304183828.GD7317@tuxdriver.com>
References: <5314357A.8090205@redpinesignals.com> <20140304183828.GD7317@tuxdriver.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Tue, 4 Mar 2014 21:08:26 +0100
Message-ID: <CAOiHx==y9aSLA+Whr9A1xo7ikp7pDMtotc7=gPPZfPNLjap8rA@mail.gmail.com> (sfid-20140304_210907_731618_AA23024D)
Subject: Re: [PATCH 3.14.0-rc5 v3 1/10] rsi: Adding RS9113 driver files
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Fariya Fatima <fariya.f@redpinesignals.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 4, 2014 at 7:38 PM, John W. Linville <linville@tuxdriver.com> wrote:
> Does anyone have any last objections or criticisms to this patch series?

> On Mon, Mar 03, 2014 at 01:25:38PM +0530, Fariya Fatima wrote:
>> Kconfig               |    1
>> Makefile              |    1

A minor critique would be that these Kconfig/Makefile changes should
be added in the last patch, else any in-between will result in a state
where the driver is selectable, but fails to build because of missing
source files.

Also the subject suggests the patch set was based on linus' tree, not
wireless-next (or whatever the correct tree is), but this does not
necessarily mean it does not apply; I did not test this.


Regards
Jonas
