Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753428AbeGFKcr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 06:32:47 -0400
Date: Fri, 6 Jul 2018 12:32:44 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 11/11] mt76: Kconfig and Makefile for mt76x0 driver
Message-ID: <20180706103244.GA2033@redhat.com> (sfid-20180706_123251_618533_F2A95C81)
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
 <1530771142-4118-12-git-send-email-sgruszka@redhat.com>
 <20180705145018.GA17524@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180705145018.GA17524@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 05, 2018 at 04:50:19PM +0200, Lorenzo Bianconi wrote:
> On Jul 05, Stanislaw Gruszka wrote:
> > +obj-$(CONFIG_MT76x0U)    += mt76x0.o
> > +
> > +mt76x0-objs	= \
> > +	usb.o init.o main.o mcu.o trace.o dma.o eeprom.o phy.o \
> 
> There is no main.c source file, is it a leftover from previous implementation?
> Moreover compiling the driver (and fixing conflicts with mt76x2u) I have:
> 
> ERROR: "mt76x0_ops" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.ko] undefined!

I somehow missed the patch adding main.c .

Stanislaw
