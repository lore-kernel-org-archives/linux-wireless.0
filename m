Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaATSsu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 13:48:50 -0500
Date: Mon, 20 Jan 2014 19:50:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sergei Antonov <saproj@gmail.com>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: USB rt2x00 driver regression
Message-ID: <20140120185044.GA1682@redhat.com> (sfid-20140120_194853_061928_413E2640)
References: <CABikg9yZrXX=qfqeR+V77u+Ndegx50D1_POAYMeq63qJuEzv=w@mail.gmail.com>
 <20140117100613.GD1425@redhat.com>
 <A411C6B4-8474-47AC-97E1-0D92B24EB675@gmail.com>
 <1390133995.6945.11.camel@X1Carbon.localdomain>
 <03574886-F38F-461C-97FC-B10DCCCF30E8@gmail.com>
 <52DC1761.9080608@openwrt.org>
 <CABikg9zdW7GjaaghfW3fLcPKEiF0-3P5Ht2DY9hx6r0-XcguRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABikg9zdW7GjaaghfW3fLcPKEiF0-3P5Ht2DY9hx6r0-XcguRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 20, 2014 at 12:20:05PM +0100, Sergei Antonov wrote:
> On 19 January 2014 19:20, Gabor Juhos <juhosg@openwrt.org> wrote:
> > The attached patch set adds the missing code to rt2x00. Please test whether it
> > fixes the problem or not.
> 
> It does not work.
> 
> The minimal change that fixes the problem is removing 'return;' after
> rt2800_mcu_request() allowing the standard freq. adjustment code to
> execute.

Perhaps this MCU request is not supported by old firmware from
linux-firmware repository.

Please download binary file accessible from this link
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2013-January/005610.html
and replace rt2870.bin file in /lib/firmware directory.

Does it help ?

Stanislaw

