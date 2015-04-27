Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33939 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbD0FIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 01:08:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Nuno =?utf-8?Q?Gon=C3=A7alves?= <nunojpg@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Ubuntu regulatory database
References: <CAEXMXLSucPD3x6igB6pLs=8cBmc-oY0Ah+nLA3kVfS1y6kLhLQ@mail.gmail.com>
	<20150425190912.GA1706@ubuntu-xps13>
Date: Mon, 27 Apr 2015 08:08:01 +0300
In-Reply-To: <20150425190912.GA1706@ubuntu-xps13> (Seth Forshee's message of
	"Sat, 25 Apr 2015 14:09:13 -0500")
Message-ID: <87y4leqhu6.fsf@kamboji.qca.qualcomm.com> (sfid-20150427_070815_324035_F29D578D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seth Forshee <seth.forshee@canonical.com> writes:

> On Sat, Apr 25, 2015 at 06:26:34PM +0100, Nuno Gonçalves wrote:
>> I was surprised that the wireless regdb provided with Ubuntu 15.04 is
>> almost 2 years old.
>> 
>> Are you aware of the reason Ubuntu is not providing a updated regdb by default?
>
> This doesn't really seem on topic for the mailing list as it's a distro
> issue.
>
> But yes, it recently came to my attention that our distro package hadn't
> been updated in a while (I don't maintain the distro package and
> obviously wasn't paying close enough attention). It will be updated
> soon.

Oh, so does this mean that the old regdb doesn't support 80 MHz
channels? Is there any way to make it easier to update the regdb in
older Ubuntu versions?

-- 
Kalle Valo
