Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33568 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0GVGct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 02:32:49 -0400
Received: by yxg6 with SMTP id 6so353453yxg.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 23:32:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201007221423.28805.br1@einfach.org>
References: <AANLkTimWWGlhEhIRol_5kjhIIEILLgDuMmUXUHCCVUC1@mail.gmail.com>
	<201007221423.28805.br1@einfach.org>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Thu, 22 Jul 2010 16:32:27 +1000
Message-ID: <AANLkTik7fL5K0NnxMHj2cWm6ZBHAwLOpn7HjL4X4xLds@mail.gmail.com>
Subject: Re: ath5k debug mode
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 3:23 PM, Bruno Randolf <br1@einfach.org> wrote:
> seems like ath5k is not compiled with debugging enabled (did you set
> CONFIG_ATH5K_DEBUG=y?), or you are using the wrong (old) module?

I copied the ath5k-debug config over config.mk and ran make. Make
appears to run gen-compat-autoconf with this new config, and I
double-checked that the config had CONFIG_ATH5K_DEBUG=y set.

I install the modules using: make install

When I modprobe ath5k in verbose mode, it is correctly loading the
modules from the updates directory.

Is this the correct way to do it?

Thanks heaps for replying!
--
Jonathan Guerin
