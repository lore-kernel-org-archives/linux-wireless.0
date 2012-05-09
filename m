Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64267 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2EIJlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 05:41:25 -0400
Received: by yhmm54 with SMTP id m54so49556yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 02:41:25 -0700 (PDT)
Date: Wed, 9 May 2012 04:41:11 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: Re: brcmsmac still woes, possible regression?
Message-ID: <20120509094111.GA2333@burratino> (sfid-20120509_114129_679401_8B1CA9BC)
References: <4F717EA1.4060805@broadcom.com>
 <4F72F3D4.50409@broadcom.com>
 <20120328112657.GA6114@stt008.linux.site>
 <4F7302D9.8070009@broadcom.com>
 <CAKprTDHz0d=W1472KcHuD-Zda9dCUX+5nKfEX55UfiNBeQ7T2w@mail.gmail.com>
 <4F744DD8.8010004@broadcom.com>
 <20120329133835.GA5196@stt008.linux.site>
 <CAKprTDFxqYq7jMm3z19xEt4NBeN9FbcR0pez9BSjY6R8kZC5KA@mail.gmail.com>
 <20120402215005.GA13969@burratino>
 <4F7B179F.7070502@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4F7B179F.7070502@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Arend van Spriel wrote, about a month ago[1]:

> I sent the patch to Camaleón to test it before sending out the
> patch. So the answer it definitely no. I wanted to get it into rc1,
> but we missed that.

Any news?  If there's a patch that goes in the right direction with
known problems I'd still be interested in it, among other reasons
because it would make the bug more concrete and make it easier to
think about possible fixes.

Thanks,
Jonathan

[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/87873/focus=88279
