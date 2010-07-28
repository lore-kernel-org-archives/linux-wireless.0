Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47072 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab0G1UVy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 16:21:54 -0400
Subject: Re: [BUG] after starting wimaxd at boot iwlagn module will crash
 for intel 6250 card
From: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wimax@linuxwimax.org" <wimax@linuxwimax.org>
In-Reply-To: <1280351645.2700.8.camel@dcbw.foobar.com>
References: <201007280028.48674.alexxy@gentoo.org>
	 <1280270313.26204.288.camel@localhost.localdomain>
	 <201007282154.06383.alexxy@gentoo.org>
	 <1280340597.26204.300.camel@localhost.localdomain>
	 <1280341422.26204.307.camel@localhost.localdomain>
	 <1280351645.2700.8.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 13:21:43 -0700
Message-ID: <1280348503.26204.357.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-28 at 14:14 -0700, Dan Williams wrote:
... 
> > ... 
> > kernel: iwlagn 0000:02:00.0: RF_KILL bit toggled to enable radio.
> > NetworkManager: <info>  WiFi now disabled by radio killswitch
> > kernel: i2400m_usb 2-1.3:1.0: 'RF Control' (0x4602) command failed: -84 - invalid state (3)
> > NetworkManager: <info>  (wlan0): bringing up device.
> > kernel: iwlagn 0000:02:00.0: Microcode SW error detected.  Restarting
> > ...
> > 
> > I say seemingly because I don't remember NetworkManager actually doing
> > that on WiMAX devices, but I could be wrong, as they expose an RFKILL
> > interface.
> 
> NM doesn't do anything yet with wimax devices, though it'll look for
> wimax killswitches.  But nothing is done with them yet upstream.
> 
> So I guess my question here is whether Alexey is using a stock NM or a
> distro-patched one.  Ubuntu used to patch NM to actually poke the rfkill
> bits, not sure if they still do that or not.  Fedora does not, and I
> don't think Novell/SUSE does either.

Thanks for the clarification Dan, that eliminates a variable :)

