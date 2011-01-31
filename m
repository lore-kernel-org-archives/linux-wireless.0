Return-path: <linux-wireless-owner@vger.kernel.org>
Message-Id: <4D46B4340200002300027E82@novprvlin0050.provo.novell.com>
Date: Sun, 30 Jan 2011 19:08:04 -0700
From: "Joey Lee" <jlee@novell.com>
To: <ozan@pardus.org.tr>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
	<platform-driver-x86@vger.kernel.org>
Subject: Re: Rfkill always soft/hard blocked upon boot
References: <4D455DC1.6010909@pardus.org.tr>
 <4D45B338.8010802@lwfinger.net> <4D45B776.4000403@pardus.org.tr>
In-Reply-To: <4D45B776.4000403@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ozan, 

於 日，2011-01-30 於 21:09 +0200，Ozan Çağlayan 提到：
> On 30.01.2011 20:51, Larry Finger wrote:
> 
> > The nature of that Fn-F2 key depends on how the motherboard manufacturer coded
> > their BIOS. Most do it as a toggle and use some WMI (Windows Management
> > Interface) code to initialize it on boot up. As this no-name laptop is unlikely
> > to have a WMI driver the way that name brands do, it probably generates a
> > keystroke. That is easy to check - Use CTRL-ALT-F1 to switch to a console, log
> > in, and issue the command "showkey". Is a keycode returned when Fn-F2 is pressed?
> 
> Hmm I've got it. So maybe taking look at the ACPI tables/WMI block can 
> reveal a way to initialize the toggle? I'm not really experienced in 
> these things but I'll take a look out of curiosity.
> 
> Thanks!
> 
> 

Does it possible share your machine's model name, dmidecode and
acpidump?


Thank's
Joey Lee

