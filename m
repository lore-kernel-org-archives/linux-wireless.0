Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaLDBYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 20:24:08 -0500
Date: Wed, 3 Dec 2014 17:24:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Parth Sane <laerdevstudios@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	driverdev-devel@linuxdriverproject.org
Subject: Ralink 6570 / Mediatek MT7601STA (was Re: Addition of a wifi kernel
 module to the linux source tree)
Message-ID: <20141204012407.GA31191@kroah.com> (sfid-20141204_022412_564581_D0BA2FD1)
References: <CAD-4tLW3cvGrw3MYiLQni7OMJYGa=QJbrk_q9=9P2QuBb1EVFg@mail.gmail.com>
 <CA+55aFw6zo4rTsEEX5uQe+8zeNR87JzmM8T=wYW7jvrHZPjB8A@mail.gmail.com>
 <20141129191601.GA1234@kroah.com>
 <CAD-4tLXYVtKJMWYW6cQ9aCL6rusUx3YpWSHys4xcTRN_dJ+kOA@mail.gmail.com>
 <20141130184615.GA3122@kroah.com>
 <CAD-4tLU-3otYOTO98s359z80SSbTJbiSstAYijiU__ekOPJkOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD-4tLU-3otYOTO98s359z80SSbTJbiSstAYijiU__ekOPJkOA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 30, 2014 at 06:55:12PM +0000, Parth Sane wrote:
> Hi Greg,
> You can find the source code attached as a tarball. It works and I have tested
> it myself. You only need to use make and make install for this.

This really looks like a variant of some existing devices, the rt2x00,
Ralink driver.

I've copied the maintainers of that driver here.

Is anyone working on support for the following devices in the existing
rt2x00 USB driver:

        {USB_DEVICE(0x148f, 0x6570)}, /* Ralink 6570 */
        {USB_DEVICE(0x148f, 0x7650)}, /* MT7650 */
        {USB_DEVICE(0x148f, 0x6370)}, /* Ralink 6370 */
        {USB_DEVICE(0x148f, 0x7601)}, /* MT 6370 */

thanks,

greg k-h
