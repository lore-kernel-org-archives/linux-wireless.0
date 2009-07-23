Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f192.google.com ([209.85.222.192]:49678 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbZGWWVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 18:21:50 -0400
Received: by pzk30 with SMTP id 30so705513pzk.33
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 15:21:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A68DBDE.7060504@redfish-solutions.com>
References: <4A612514.4050708@redfish-solutions.com>
	 <20090720115244.GC9972@hash.localnet>
	 <4A64C283.6090205@redfish-solutions.com>
	 <43e72e890907201247x7df76b75wf6ba2bc2260dbf7a@mail.gmail.com>
	 <4A650331.9020409@redfish-solutions.com>
	 <4A6620B9.4@redfish-solutions.com>
	 <20090723112428.GC13742@hash.localnet>
	 <b6c5339f0907230459g75cef6eag1ad0caa7b1a631b8@mail.gmail.com>
	 <4A68C821.7060208@redfish-solutions.com>
	 <4A68DBDE.7060504@redfish-solutions.com>
Date: Thu, 23 Jul 2009 18:21:50 -0400
Message-ID: <b6c5339f0907231521v37b44d45t1852d0c5f97bc4fb@mail.gmail.com>
Subject: Re: Using compat-wireless w/ 2.6.27.26
From: Bob Copeland <me@bobcopeland.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 5:53 PM, Philip A.
Prindeville<philipp_subx@redfish-solutions.com> wrote:
>> Getting closer :-)
>>
>> ath5k_tx_processq(sc, &sc->txqs[i]);
>>
>
> Didn't work with rc4:

What did you apply against?  It's supposed to be against
wireless-testing (or, at worst, latest compat-wireless).

> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<d0935658>] :ath5k:ath5k_tasklet_tx+0x5e/0x27b

Can you run scripts/markup_oops.pl on that?

-- 
Bob Copeland %% www.bobcopeland.com
