Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:42639 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYEVPqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 11:46:13 -0400
Received: by el-out-1112.google.com with SMTP id s27so75162ele.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 08:46:12 -0700 (PDT)
Message-ID: <f6ca9fed0805220846w3670fbe1i1cb28cc2d1b97288@mail.gmail.com> (sfid-20080522_174616_294968_0A534157)
Date: Thu, 22 May 2008 17:46:11 +0200
From: drago01 <drago01@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH WIP] rtl8187b support
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1211470467.10933.57.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211470467.10933.57.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2008 at 5:34 PM, Pavel Roskin <proski@gnu.org> wrote:

> +       rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
> +       rtl8225_write(dev, 0x1, 0xEE0); msleep(1);
> +       rtl8225_write(dev, 0x2, 0x44D); msleep(1);
> +       rtl8225_write(dev, 0x3, 0x441); msleep(1);
> +       rtl8225_write(dev, 0x4, 0x8C3); msleep(1);
> +       rtl8225_write(dev, 0x5, 0xC72); msleep(1);
> +       rtl8225_write(dev, 0x6, 0x0E6); msleep(1);
> +       rtl8225_write(dev, 0x7, 0x82A); msleep(1);
> +       rtl8225_write(dev, 0x8, 0x03F); msleep(1);
> +       rtl8225_write(dev, 0x9, 0x335); msleep(1);
> +       rtl8225_write(dev, 0xa, 0x9D4); msleep(1);
> +       rtl8225_write(dev, 0xb, 0x7BB); msleep(1);
> +       rtl8225_write(dev, 0xc, 0x850); msleep(1);
> +       rtl8225_write(dev, 0xd, 0xCDF); msleep(1);
> +       rtl8225_write(dev, 0xe, 0x02B); msleep(1);
> +       rtl8225_write(dev, 0xf, 0x114); msleep(1);

wouldn't it make sense to let rtl8225_write always call msleep(1) ?
