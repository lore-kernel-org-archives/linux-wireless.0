Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34597 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2EIK3f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 06:29:35 -0400
Received: by yhmm54 with SMTP id m54so82760yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 03:29:35 -0700 (PDT)
Date: Wed, 9 May 2012 05:29:26 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: Re: brcmsmac still woes, possible regression?
Message-ID: <20120509102926.GD3499@burratino> (sfid-20120509_122939_583563_2BACA0B2)
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
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FAA45AF.8050201@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel wrote:
> On 05/09/2012 11:41 AM, Jonathan Nieder wrote:

>> Any news?  If there's a patch that goes in the right direction with
>> known problems I'd still be interested in it, among other reasons
>> because it would make the bug more concrete and make it easier to
>> think about possible fixes.
>
> Well, there is the short term fix, which is already upstream and moved
> to stable. The long term fix for which Seth Forshee (Canonical) did a
> great job is reviewed over here, but it involves regulatory related code
> so it needs discussions with our compliance team and supervisor. So that
> causes some lag time.
>
> If you are using a kernel with the short term fix included please sent
> any logging information if the problem still persists.

Thanks for explaining.  That makes sense.

Is the short term fix badc4f07622f ("brcm80211: smac: resume transmit
fifo upon receiving frames", 2012-04-11)?

Thanks,
Jonathan
