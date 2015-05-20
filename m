Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:42914 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753388AbbETQq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 12:46:27 -0400
Date: Wed, 20 May 2015 19:46:13 +0300
From: Petko Manolov <petkan@mip-labs.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150520164613.GD10473@localhost> (sfid-20150520_184636_133144_2A2A1DCE)
References: <20150519200232.GM23057@wotan.suse.de>
 <20150520140426.GB126473@ubuntu-hedt>
 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-05-20 17:24:46, One Thousand Gnomes wrote:
> 
> More to the point why do you want to sign firmware files ? Leaving aside the 
> fact that someone will produce a device with GPLv3 firmware just to p*ss you 
> off there's the rather more relevant fact that firmware for devices on a so 
> called "trusted" platform already have signed firmware.

For "trusted" systems one would like to make sure everything that goes in has 
known provenance.  Maybe this was the idea?

> For external devices I don't normally have access to read system memory 
> anyway, and signing firmware would achieve nothing unless you start doing 
> crazy DRM style key exchanges to prove the endpoint is trusted. Any NSA trojan 
> wifi stick is simply going to nod as the correct firmware is uploaded, and 
> then ignore it. And if I'm just out to be a pain I can already just plug in a 
> fake device claiming to be a usb disk with 256 bytes per sector (boom... exit 
> machine stage right), or for that matter wire a USB stick with 5v connected to 
> the mains at the nearest wall socket.

Yep, gaining physical access to the system is a game over.  It is arguable how 
"trusted" a networked machine could be and i guess the answer is "not much"...


		Petko
