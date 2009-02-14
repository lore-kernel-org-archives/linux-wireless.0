Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:48667
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbZBNCnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 21:43:25 -0500
Message-ID: <49962FC9.2040406@erley.org> (sfid-20090214_034329_431506_E8F89B83)
Date: Fri, 13 Feb 2009 21:43:21 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Vitja Makarov <vitja.makarov@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: compat-wireless with CONFIG_MAC80211disabled
References: <1925ef8a0902130015o6df0c962n3fe05ec420d0aef@mail.gmail.com>	 <43e72e890902130023w3c192b04r3a41b4643eedb530@mail.gmail.com>	 <1925ef8a0902130454i7b72a7fftb13cc6b77413b70c@mail.gmail.com> <43e72e890902131449n153b606fne9a6dba1af071915@mail.gmail.com>
In-Reply-To: <43e72e890902131449n153b606fne9a6dba1af071915@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Fri, Feb 13, 2009 at 4:54 AM, Vitja Makarov <vitja.makarov@gmail.com> wrote:
>> This should be problem for 2.6.27 too.
> 
> modified for 27 and applied, thanks

I didn't run into this problem with 2.6.28-gentoo-r1... I've been running 
compat-wireless from git since the 4th on this kernel, with no mac80211
enabled and had no problems.  Is there interest in a patch allowing you to
set something like FORCE=y on the CLI to override these patches?

Pat Erley
