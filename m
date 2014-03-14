Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44634 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaCNMhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 08:37:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140314084514.23100.72654.stgit@x230>
References: <20140314084501.23100.13103.stgit@x230> <20140314084514.23100.72654.stgit@x230>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 14 Mar 2014 05:36:53 -0700
Message-ID: <CAB=NE6WW8yX4kdy02j2fT4g0JvYj4a_XkiqYtXKZSMB7FHuwNg@mail.gmail.com> (sfid-20140314_133748_796259_9AE50CED)
Subject: Re: [PATCH 3/3] ath10k: add firmware files
To: Kalle Valo <kvalo@qca.qualcomm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 14, 2014 at 1:45 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> +* No Reverse engineering, decompiling, decrypting, or disassembling of
> +  this software is permitted.

We have other firmware licenses that have this language already on
linux-firmware but let us also keep in mind that linux-firmware will
likely not only be used by Linux folks.

<-- cut -->

> + NO LICENSES OR OTHER RIGHTS,
> +WHETHER EXPRESS, IMPLIED, BASED ON ESTOPPEL OR OTHERWISE, ARE GRANTED
> +TO ANY PARTY'S PATENTS, PATENT APPLICATIONS, OR PATENTABLE INVENTIONS
> +BY VIRTUE OF THIS LICENSE OR THE DELIVERY OR PROVISION BY QUALCOMM
> +ATHEROS, INC. OF THE SOFTWARE.

This -- however is new to linux-firmware -- and I hereby raise a big
red fucking flag. All other licenses on linux-firmware provide at the
very least a limited patent grant. What makes Qualcomm special ?

> +FOR ANY DIRECT DAMAGES ARISING UNDER OR RESULTING FROM
> +THIS AGREEMENT OR IN CONNECTION WITH ANY USE OF THE SOFTWARE SHALL NOT
> +EXCEED A TOTAL AMOUNT OF US$5.00.

WTF - was this inspired by a Sci-Fi movie?

  Luis
