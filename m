Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59600 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYIIVU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 17:20:28 -0400
Received: by gxk9 with SMTP id 9so11888163gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2008 14:20:27 -0700 (PDT)
Message-ID: <1ba2fa240809091420w11d3a317vdbb863c85c30e59e@mail.gmail.com> (sfid-20080909_232032_200644_183A01A7)
Date: Wed, 10 Sep 2008 00:20:26 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: jt@hpl.hp.com
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
Cc: Dave <kilroyd@googlemail.com>, "Pavel Roskin" <proski@gnu.org>,
	"Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net
In-Reply-To: <20080909193303.GA28424@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
	 <20080805162238.GA6294@bougret.hpl.hp.com>
	 <20080902230621.GA28885@bougret.hpl.hp.com>
	 <1220878110.2369.3.camel@dv>
	 <20080908183203.GA7090@bougret.hpl.hp.com>
	 <48C6C262.7010803@gmail.com>
	 <20080909193303.GA28424@bougret.hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 10:33 PM, Jean Tourrilhes <jt@hpl.hp.com> wrote:
> On Tue, Sep 09, 2008 at 07:37:22PM +0100, Dave wrote:
>>
>> Thanks for finding that Jean! I've double checked, and agree it's the right
>> fix.
>>
>> FWIW, I've verified this compiles and (still) works as expected on my 32
>> bit system.
>
>        My pleasure. Sorry for beeing so late...
>        By the way, I would not mind people looking at Wireless Tools
> v30.pre7 so that I can get feedback and make a final release.
>
My little report :)
I've tested the power (save) command. It fixes the issues in 'saving'
parameter  that are in v29.
Tomas
