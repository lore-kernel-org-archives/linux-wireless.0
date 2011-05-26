Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:38492 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932625Ab1EZP2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 11:28:49 -0400
Date: Thu, 26 May 2011 08:28:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC V1] lib: cordic: add library module for cordic angle
 calculation
Message-Id: <20110526082834.6ac25796.rdunlap@xenotime.net> (sfid-20110526_172917_475896_1F0DA2BA)
In-Reply-To: <4DDE0AB4.5020102@broadcom.com>
References: <1306352426-1899-1-git-send-email-arend@broadcom.com>
	<20110525130438.c05605c7.rdunlap@xenotime.net>
	<4DDE0AB4.5020102@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 26 May 2011 10:09:24 +0200 Arend van Spriel wrote:

> On 05/25/2011 10:04 PM, Randy Dunlap wrote:
> > On Wed, 25 May 2011 21:40:26 +0200 Arend van Spriel wrote:
> >> +/**
> >> + * struct - i/q coordinate.
> >   * struct cordic_iq - i/q coordinate
> 
> The kernel-doc processing is pretty smart here. In the current form I 
> get the html as attached. From that perspective your proposed change is 
> not needed, but if your point is that it would be more clear to the mere 
> mortal reading through the source code I can change it.

Hm, I see.  scripts/kernel-doc gets the struct name from the source code
in this case.  too smart ;)

AFAIK, everywhere else we use

/**
 * struct structname - description

and that's what Documentation/kernel-doc-nano-HOWTO.txt calls for, and
yes, it would be more readable to us mortals also, so please change it.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
