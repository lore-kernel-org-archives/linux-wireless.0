Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33050 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2DLEXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 00:23:15 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Apr 2012 21:22:53 -0700
Message-ID: <CA+55aFxWD1bE0oiR4GpLP19MCm2CzwuApuYhcE_NF7bC+tFYjg@mail.gmail.com> (sfid-20120412_062414_213592_29238711)
Subject: Regression due to "ath9k: fix going to full-sleep on PS idle"
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 11, 2012 at 9:16 PM, Heinz Diehl <htd@fancy-poultry.org> wrote:
> On 12.04.2012, Sergio Correia wrote:
>
>> is there any chance for this one to be included in this review cycle?
>>
>> http://www.spinics.net/lists/linux-wireless/msg87999.html
>
> Thanks for pointing this out! This patch fixes my network problems
> which forced me to go back to a previous kernel.

You guys need to fix the subject line (like this), and make sure that
the right people are cc'd. This is not a "stable" issue - stable
cannot revert stuff that hasn't been reverted upstream.

So instead of stable and Greg, it should be netdev and Davem.

David/John: multiple people are complaining about that commit. It
really should be reverted, or a fix found. It's broken.

I can do the revert, but it would be better coming from the networking people.

                         Linus
