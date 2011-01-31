Return-path: <linux-wireless-owner@vger.kernel.org>
Message-Id: <4D4727E10200002300027EDF@novprvlin0050.provo.novell.com>
Date: Mon, 31 Jan 2011 03:21:37 -0700
From: "Joey Lee" <jlee@novell.com>
To: <ozan@pardus.org.tr>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
	<platform-driver-x86@vger.kernel.org>
Subject: Re: Rfkill always soft/hard blocked upon boot
References: <4D455DC1.6010909@pardus.org.tr>
 <4D45B338.8010802@lwfinger.net> <4D45B776.4000403@pardus.org.tr>
 <4D46B4340200002300027E82@novprvlin0050.provo.novell.com>
 <4D467AFC.7090503@pardus.org.tr>
In-Reply-To: <4D467AFC.7090503@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oza, 

於 一，2011-01-31 於 11:03 +0200，Ozan Çağlayan 提到：
> On 31.01.2011 04:08, Joey Lee wrote:
> 
> > Does it possible share your machine's model name, dmidecode and
> > acpidump?
> 
> Yes of course. I have the acpidump and dmidecode outputs but I could not 
> extract the tables from the acpidump output. It gave an error about the 
> table headers and their lengths.
> 

No, I CAN dump the tables from your acpidump result, you need:

(assume you save the dump result to acpidump-test.dat)
acpixtract acpidump-test.dat
iasl -d DSDT.dsl

> This is a local (Turkish) brand laptop. The manufacturer is Casper. 
> Model is Nirvana i7 (Casper Nirvana i7 CNTKI-620A). It can be an exact 
> clone-copy of a popular laptop as it happens with these no-name stuff.
> 
> acpidump:
>   http://bugs.pardus.org.tr/attachment.cgi?id=6673
> 
> dmidecode:
>   http://bugs.pardus.org.tr/attachment.cgi?id=6674
> 
> 

Sorry, I am not good for this platform, but will check your DSDT.


Thank's
Joey Lee
> 
> 
> 


