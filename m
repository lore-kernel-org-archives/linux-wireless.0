Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39040 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab2DNCs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 22:48:57 -0400
MIME-Version: 1.0
In-Reply-To: <1334371116.17649.1.camel@phoenix>
References: <1334371116.17649.1.camel@phoenix>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Fri, 13 Apr 2012 19:48:36 -0700
Message-ID: <CAB=NE6UgiZ6qqJ2W-Pb-g-BMv71-kYSLzJxbyV-XDEzNkCeffQ@mail.gmail.com> (sfid-20120414_044907_497568_9613DCC9)
Subject: Re: [PATCH] net/wireless: use module_pci_driver
To: Axel Lin <axel.lin@gmail.com>
Cc: netdev@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Simon Kelley <simon@thekelleys.org.uk>,
	Jouni Malinen <j@w1.fi>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 13, 2012 at 7:38 PM, Axel Lin <axel.lin@gmail.com> wrote:
> module_pci_driver

Neat, any chance you can you send me a respective patch to add
module_pci_driver() to compat so that when we backport all this is
done automatically?

git://github.com/mcgrof/compat.git

 Luis
