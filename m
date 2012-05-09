Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3561 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab2EIKcf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 06:32:35 -0400
Message-ID: <4FAA47B4.5090002@broadcom.com> (sfid-20120509_123238_864710_4544DB39)
Date: Wed, 9 May 2012 12:32:20 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonathan Nieder" <jrnieder@gmail.com>
cc: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: brcmsmac still woes, possible regression?
References: <20120328112657.GA6114@stt008.linux.site>
 <4F7302D9.8070009@broadcom.com>
 <CAKprTDHz0d=W1472KcHuD-Zda9dCUX+5nKfEX55UfiNBeQ7T2w@mail.gmail.com>
 <4F744DD8.8010004@broadcom.com>
 <20120329133835.GA5196@stt008.linux.site>
 <CAKprTDFxqYq7jMm3z19xEt4NBeN9FbcR0pez9BSjY6R8kZC5KA@mail.gmail.com>
 <20120402215005.GA13969@burratino> <4F7B179F.7070502@broadcom.com>
 <20120509094111.GA2333@burratino> <4FAA45AF.8050201@broadcom.com>
 <20120509102926.GD3499@burratino>
In-Reply-To: <20120509102926.GD3499@burratino>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2012 12:29 PM, Jonathan Nieder wrote:
> 
> Thanks for explaining.  That makes sense.
> 
> Is the short term fix badc4f07622f ("brcm80211: smac: resume transmit
> fifo upon receiving frames", 2012-04-11)?
> 
> Thanks,
> Jonathan
> 

Yep. I remember because the SHA1 start with 'bad', which felt like a
certain kind of omen to me ;-)

Gr. AvS

