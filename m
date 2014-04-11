Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:38186 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaDKUQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 16:16:14 -0400
Date: Fri, 11 Apr 2014 22:16:11 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <1423252643.20140411221611@eikelenboom.it> (sfid-20140411_221628_160050_DBC82323)
To: Johannes Berg <johannes@sipsolutions.net>
CC: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <collen@cozybit.com>
Subject: Re: [RFC/RFT] cfg80211: reg: track crda request
In-Reply-To: <1397247226.4643.8.camel@jlt4.sipsolutions.net>
References: <1397219374-3280-1-git-send-email-janusz.dziedzic@tieto.com> <2710039777.20140411192110@eikelenboom.it> <CAFED-jkPtXU8moGrb4XiriU-c7WokgSiXq6g0jCLOhk3dJnoLg@mail.gmail.com> <294574679.20140411220931@eikelenboom.it> <1397247226.4643.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Friday, April 11, 2014, 10:13:46 PM, you wrote:

> On Fri, 2014-04-11 at 22:09 +0200, Sander Eikelenboom wrote:

>> I would first like to know if Johannes likes this solution or not.

> Heh, I guess that's only fair.

>> With previous patches from Luis they were blocked after testing and debugging, so let him 
>> first speak out if he likes the approach or not.

> I think this looks fine. My main complaint with Luis's patches (besides
> reportedly breaking some other use cases) was that he was piggy-backing
> on some completely unrelated thing to try to recover something. Here we
> have an explicit delayed work struct so that seems fine.

> And I really like the part where Janusz moves the delayed_work setting
> where it belongs - the CRDA call function :)

Ok i will duplicate the testing tomorrow somewhat more careful and report back 
tomorrow. 

> johannes



