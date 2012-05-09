Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49313 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335Ab2EIRlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 13:41:11 -0400
Date: Wed, 9 May 2012 10:41:06 -0700
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>
Subject: Re: brcmsmac still woes, possible regression?
Message-ID: <20120509174106.GA7189@ubuntu-mba> (sfid-20120509_194126_669079_ADFCCCC9)
References: <20120328112657.GA6114@stt008.linux.site>
 <4F7302D9.8070009@broadcom.com>
 <CAKprTDHz0d=W1472KcHuD-Zda9dCUX+5nKfEX55UfiNBeQ7T2w@mail.gmail.com>
 <4F744DD8.8010004@broadcom.com>
 <20120329133835.GA5196@stt008.linux.site>
 <CAKprTDFxqYq7jMm3z19xEt4NBeN9FbcR0pez9BSjY6R8kZC5KA@mail.gmail.com>
 <20120402215005.GA13969@burratino>
 <4F7B179F.7070502@broadcom.com>
 <20120509094111.GA2333@burratino>
 <4FAA45AF.8050201@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4FAA45AF.8050201@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 09, 2012 at 12:23:43PM +0200, Arend van Spriel wrote:
> On 05/09/2012 11:41 AM, Jonathan Nieder wrote:
> > Hi Arend,
> > 
> > Arend van Spriel wrote, about a month ago[1]:
> > 
> >> I sent the patch to Camaleón to test it before sending out the
> >> patch. So the answer it definitely no. I wanted to get it into rc1,
> >> but we missed that.
> > 
> > Any news?  If there's a patch that goes in the right direction with
> > known problems I'd still be interested in it, among other reasons
> > because it would make the bug more concrete and make it easier to
> > think about possible fixes.
> 
> Well, there is the short term fix, which is already upstream and moved
> to stable. The long term fix for which Seth Forshee (Canonical) did a
> great job is reviewed over here, but it involves regulatory related code
> so it needs discussions with our compliance team and supervisor. So that
> causes some lag time.

The patches I sent still relies on the transmit-after-beacon fix, as I
preserved the behavior of muting tx if the channel is passive scan. I
*think* this isn't actually necessary, but I'd have to investigate a
little further to be certain.

Seth
