Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:43372 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbZAUAUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 19:20:21 -0500
Received: by gxk14 with SMTP id 14so3245193gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 16:20:19 -0800 (PST)
Message-ID: <43e72e890901201620l6e3a16brce18b149e7678ee6@mail.gmail.com> (sfid-20090121_012027_332821_B3B80C21)
Date: Tue, 20 Jan 2009 16:20:19 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Kyle McMartin" <kyle@infradead.org>
Subject: Re: [stable] Failed Build of modules for 2.6.27.9-159
Cc: "Greg KH" <greg@kroah.com>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Paul Hickey" <paul@christianpatriot.us>,
	"stable@kernel.org" <stable@kernel.org>,
	"Kyle McMartin" <kyle@mcmartin.ca>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090121001250.GG17452@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1232404986.3641.2.camel@localhost.localdomain>
	 <1232433738.3696.3.camel@localhost.localdomain>
	 <20090120194243.GC19581@tesla> <20090120200515.GA5077@kroah.com>
	 <20090120201316.GG19581@tesla> <20090120201613.GA5313@kroah.com>
	 <20090120211630.GJ19581@tesla>
	 <20090120220810.GE17452@bombadil.infradead.org>
	 <43e72e890901201607h359018eew3bf7f99b5d1b0759@mail.gmail.com>
	 <20090121001250.GG17452@bombadil.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 4:12 PM, Kyle McMartin <kyle@infradead.org> wrote:
> On Tue, Jan 20, 2009 at 04:07:52PM -0800, Luis R. Rodriguez wrote:
>> Thanks Kyle, that's pretty neat, unfortunately my compat.c includes
>> compat.h and since compat.h includes pci.h the compiler nags about the
>> double header redefinition of foo() where pci.h already has that
>> present (on those systems only). Essentially I'd need a way for
>> systems without foo() to define the header line and for systems that
>> already have it to not add the line. Know any trick for that?
>>
>> Any particular strong reason to add that pci inline onto FC10 headers?
>
> Well, because it came with an ALSA update...

Any chance that can be moved to ALSA specific dirs for the alsa updates?

  Luis
