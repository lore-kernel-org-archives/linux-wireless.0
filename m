Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35680 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbcADXyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 18:54:40 -0500
MIME-Version: 1.0
In-Reply-To: <568A668D.8090007@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net> <5687E169.4070704@users.sourceforge.net>
 <5687E203.1070404@users.sourceforge.net> <20160104092857.GD5284@mwanda>
 <568A4CFF.8060600@users.sourceforge.net> <20160104114849.GH5284@mwanda> <568A668D.8090007@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 5 Jan 2016 10:54:19 +1100
Message-ID: <CAGRGNgXw+G6ZcmFmM=VWZT_jibuZyxe-kSvPSF8W7hPueLhNrw@mail.gmail.com> (sfid-20160105_005445_501923_F9C44FC1)
Subject: Re: rsi: Delete unnecessary variable initialisations in rsi_send_mgmt_pkt()
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Markus,

On Mon, Jan 4, 2016 at 11:33 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>>> May I resend a consistent patch series for the source file
>>> "drivers/net/wireless/rsi/rsi_91x_pkt.c" in the near future?
>>
>> If you were sending checkpatch.pl fixes that would be easier to deal with
>
> Does this feedback mean that you would accept any more suggestions around
> source code updates which are derived from recommendations of this script?

A good rule of thumb here would be that if people start complaining
about a particular type of change, stop sending them.

Another good rule of thumb is to try to "rock the boat" on coding
style and conventions as little as possible. Just because it's
possible doesn't mean that people want to do it.

That said, if you figure out some change that produces significant
reductions in code or binary size on multiple architectures without
making things more complicated, less readable or making the code or
binary size larger, then by all means propose it. "This makes things
smaller" carries much more weight than "I think this is better".
Almost all of the changes you've proposed that have seen any
discussion whatsoever fall into the latter category.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
