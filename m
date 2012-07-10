Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bluegiga.fi ([194.100.31.45]:34773 "EHLO darkblue.bluegiga.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab2GJKJr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 06:09:47 -0400
Message-ID: <4FFBFCF0.6030506@bluegiga.com> (sfid-20120710_120950_871998_0DC577F8)
Date: Tue, 10 Jul 2012 12:59:12 +0300
From: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Woody Hung <Woody.Hung@mediatek.com>
Subject: Re: [PATCH 1/2] rt2x00pci: small 3290 changes cleanup
References: <1341837708-22689-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1341837708-22689-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 03:41 PM, Stanislaw Gruszka wrote:
> Fix indention and remove unnecessary brackets and compares.

Hi,

Otherwise looks ok but I have a one comment, see below.

> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>   drivers/net/wireless/rt2x00/rt2800pci.c |   11 +++++------
>   1 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index dd43612..bf0e71e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c

<snip>

> @@ -1022,9 +1022,8 @@ static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
>   			rt2800_register_write(rt2x00dev, 0x58, 0x618);
>   			udelay(REGISTER_BUSY_DELAY);
>   			count++;
> -		} else {
> +		} else
>   			count = 0;
> -		}

I have understood that Linux CodingStyle requires braces on all else/if 
branches if any of those have more than one statement. So I would not 
remove braces here.

--
Veli-Pekka Peltola
