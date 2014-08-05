Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:59071 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaHEQvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 12:51:09 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [PATCHv5 0/2] ath10k spectral scan support
Date: Tue, 5 Aug 2014 18:51:06 +0200
Cc: ath10k@lists.infradead.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Kathy Giori <kgiori@qca.qualcomm.com>,
	Sven Eckelmann <sven@narfation.org>,
	mathias.kretschmer@fokus.fraunhofer.de
References: <1406899034-13473-1-git-send-email-sw@simonwunderlich.de> <CAB=NE6XOquKeF3JTCDBUJhtjtUYGjPi2tG7By+1Ntyk-_Km6rg@mail.gmail.com>
In-Reply-To: <CAB=NE6XOquKeF3JTCDBUJhtjtUYGjPi2tG7By+1Ntyk-_Km6rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201408051851.06457.sw@simonwunderlich.de> (sfid-20140805_185114_237401_ABBD7421)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On Fri, Aug 1, 2014 at 6:17 AM, Simon Wunderlich <sw@simonwunderlich.de> 
wrote:
> > To view the samples, please have a look at the fft_eval tool [1] which
> > now supports both ath9k and ath10k formats.
> 
> Can you please edit the ath9k and ath10k wiki about this tool and
> reference to it?

Thanks for pointing that out. I've updated ath9k with some instructions how to 
actually run the spectral scan. A link to the tool was already included. I've 
also added an ath10k page with test instructions and description of the 
debugfs files, including a reference to fft_eval. Feel free to 
update/improve/edit, everyone. :)

I did not update the iw page because there is (no longer) any changes 
neccesary in iw for running spectral - we had this only in the very first 
version of the ath9k patch. I've updated the README/usage in fft_eval to 
reflect that properly, though.

Thanks,
    Simon
