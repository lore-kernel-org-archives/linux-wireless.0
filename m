Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ar100.montanavision.com ([216.146.103.100]:43176 "EHLO
	silka.with-linux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2DCHrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 03:47:09 -0400
Message-ID: <4F7AAAD9.2040307@silka.with-linux.com> (sfid-20120403_094713_893016_E8520425)
Date: Tue, 03 Apr 2012 01:46:33 -0600
From: Kelly Anderson <kelly@silka.with-linux.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: Ben Greear <greearb@candelatech.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] 3.3.1 ath9k regression
References: <4F7A8EB7.4060200@silka.with-linux.com> <4F7A923D.5000002@candelatech.com> <CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com> <4F7A9D5C.8040402@silka.with-linux.com> <CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
In-Reply-To: <CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2012 01:16 AM, Mohammed Shafi wrote:
> Hi Kelly,
>
> could you please try to see by disabling ASPM in the boot option and
> see if it helps

I just tried the unpatched kernel with pcie_aspm=off.  The device shows 
up with ifconfig,
but it will not connect to the access point.


>
> http://linuxwireless.org/en/users/Documentation/ASPM
>
> pcie_aspm=      [PCIE] Forcibly enable or disable PCIe Active State Power
> off     Disable ASPM.
>

