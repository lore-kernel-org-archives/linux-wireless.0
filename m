Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1624 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab2EIKX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 06:23:57 -0400
Message-ID: <4FAA45AF.8050201@broadcom.com> (sfid-20120509_122400_809428_75AFF8FD)
Date: Wed, 9 May 2012 12:23:43 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonathan Nieder" <jrnieder@gmail.com>
cc: =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: brcmsmac still woes, possible regression?
References: <4F717EA1.4060805@broadcom.com>
 <4F72F3D4.50409@broadcom.com> <20120328112657.GA6114@stt008.linux.site>
 <4F7302D9.8070009@broadcom.com>
 <CAKprTDHz0d=W1472KcHuD-Zda9dCUX+5nKfEX55UfiNBeQ7T2w@mail.gmail.com>
 <4F744DD8.8010004@broadcom.com>
 <20120329133835.GA5196@stt008.linux.site>
 <CAKprTDFxqYq7jMm3z19xEt4NBeN9FbcR0pez9BSjY6R8kZC5KA@mail.gmail.com>
 <20120402215005.GA13969@burratino> <4F7B179F.7070502@broadcom.com>
 <20120509094111.GA2333@burratino>
In-Reply-To: <20120509094111.GA2333@burratino>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2012 11:41 AM, Jonathan Nieder wrote:
> Hi Arend,
> 
> Arend van Spriel wrote, about a month ago[1]:
> 
>> I sent the patch to Camaleón to test it before sending out the
>> patch. So the answer it definitely no. I wanted to get it into rc1,
>> but we missed that.
> 
> Any news?  If there's a patch that goes in the right direction with
> known problems I'd still be interested in it, among other reasons
> because it would make the bug more concrete and make it easier to
> think about possible fixes.

Well, there is the short term fix, which is already upstream and moved
to stable. The long term fix for which Seth Forshee (Canonical) did a
great job is reviewed over here, but it involves regulatory related code
so it needs discussions with our compliance team and supervisor. So that
causes some lag time.

If you are using a kernel with the short term fix included please sent
any logging information if the problem still persists.

Gr. AvS

