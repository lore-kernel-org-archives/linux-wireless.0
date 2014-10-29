Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbaJ2LwD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:52:03 -0400
Date: Wed, 29 Oct 2014 12:48:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Cyril Brulebois <kibi@debian.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: rt2x00: add new rt2800usb device
Message-ID: <20141029114846.GC2021@redhat.com> (sfid-20141029_125242_756349_6D7BD9BE)
References: <1414510961-28920-1-git-send-email-kibi@debian.org>
 <20141029110214.GB2021@redhat.com>
 <20141029111224.GC29720@mraw.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141029111224.GC29720@mraw.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2014 at 12:12:24PM +0100, Cyril Brulebois wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> (2014-10-29):
> > On Tue, Oct 28, 2014 at 04:42:41PM +0100, Cyril Brulebois wrote:
> > > 0x1b75 0xa200 AirLive WN-200USB wireless 11b/g/n dongle
> > > 
> > > References: https://bugs.debian.org/766802
> > > Reported-by: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
> > 
> > Was this patch tested by reporter? I would rather see Reported-and-tested-by tag :-)
> 
> The reporter confirmed the following trick worked:
> 
>   # echo rt2800usb >> /etc/modules
>   # echo 'install rt2800usb /sbin/modprobe --ignore-install rt2800usb $CMDLINE_OPTS && echo 1b75 a200 > /sys/bus/usb/drivers/rt2800usb/new_id' > /etc/modprobe.d/ralink.conf
>   # modprobe -r rt2800usb ; modprobe rt2800usb

Ok, that's fine .

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

