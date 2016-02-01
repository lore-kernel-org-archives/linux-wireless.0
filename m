Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37104 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595AbcBAEa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 23:30:58 -0500
MIME-Version: 1.0
In-Reply-To: <20160201042548.GA4072@sudip-pc>
References: <1454060944-11320-1-git-send-email-sudipm.mukherjee@gmail.com>
 <CAGRGNgXc9PtYY=hb8nNRt4T5YGm2vexcJ01Z1fCCcb=57WRZ3g@mail.gmail.com> <20160201042548.GA4072@sudip-pc>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 1 Feb 2016 15:30:38 +1100
Message-ID: <CAGRGNgUDPiCJqnSzboP6mvNdmW5T74aUfbSRs5SP8HMgZQBFJw@mail.gmail.com> (sfid-20160201_053115_509432_004DCEE9)
Subject: Re: [PATCH] mac80211: fix memory leak
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sudip,

On Mon, Feb 1, 2016 at 3:25 PM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> On Mon, Feb 01, 2016 at 11:03:35AM +1100, Julian Calaby wrote:
>> Hi Sudip,
>>
>> On Fri, Jan 29, 2016 at 8:49 PM, Sudip Mukherjee
>> <sudipm.mukherjee@gmail.com> wrote:
>> > On error we jumped to the error label and returned the error code but we
>> > missed releasing sinfo.
>> >
>> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
>>
>> Should the From: and Signed-off-by: email addresses be the same?
>
> I think 2 years back I had a long discussion with Greg about this and
> since then I al submitting patches like this. A small summayg of the
> problem from that discussion:
>
> "we have strict DMARC check for the corporate mail server. DMARC =
> domain based message authentication.
> So the mail i sent reached all the list subscriber from a different
> server than our designated server, and as a result it is marked as spam
> in many places and I have already received a few complaints regarding
> that."

Ok, fair enough then.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
