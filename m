Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4113 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbYE1M6h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 08:58:37 -0400
Date: Tue, 27 May 2008 20:21:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Larabel <michael.larabel@phoronix.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: b43: Radio Hardware Status Disabled
Message-ID: <20080528002120.GD7779@tuxdriver.com> (sfid-20080528_145840_475716_531E2D3E)
References: <4837859B.3050100@phoronix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4837859B.3050100@phoronix.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 23, 2008 at 11:03:55PM -0400, Michael Larabel wrote:
> With a Linksys WUSB600N and NetGear WNDA3100, which both appear to utilize 
> a Broadcom 4311 chipset, the radio hardware status always seems to get set 
> to disabled immediately after the wireless interface is started and are 
> never re-enabled.
>
> This is happening with the b43 driver (found in Linux 2.6.25.3 kernel) on 
> Fedora 9. Below is the dmesg and lspci output.

Did you open a corresponding bug at bugzilla.redhat.com?  If not,
please do so (and CC: linville@redhat.com if you don't mind).

What is the latest F9 kernel you have tried?  Could you try one of
the latest ones from Koji?

	http://koji.fedoraproject.org/koji/buildinfo?buildID=50055

The wireless bits in the freshly installed F9 kernels are a bit old,
so I want to make sure you are working with modern code.

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
