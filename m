Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:41063 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZCWIVJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 04:21:09 -0400
Received: by ey-out-2122.google.com with SMTP id 4so491592eyf.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 01:21:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090323030419.GA5803@hash.localnet>
References: <20090226230338.M86894@bobcopeland.com>
	 <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com>
	 <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet>
	 <20090227023912.GF13456@tesla> <20090227030608.GA29974@hash.localnet>
	 <1235884912.9224.26.camel@mj> <20090303034600.GA3757@hash.localnet>
	 <40f31dec0903022031l20ecc3dcx9ba7859cb24fa5ae@mail.gmail.com>
	 <20090323030419.GA5803@hash.localnet>
Date: Mon, 23 Mar 2009 10:21:05 +0200
Message-ID: <40f31dec0903230121l3fe96c6em74d98d3410071a62@mail.gmail.com> (sfid-20090323_092114_359716_FF4B6475)
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/23 Bob Copeland <me@bobcopeland.com>:
> On Tue, Mar 03, 2009 at 06:31:05AM +0200, Nick Kossifidis wrote:
>> and i don't believe i've ever seen them, so we can warn on them too
>> and print something like "Reserved rate code: %x", also it would be
>> nice to warn on XR rates (1,2,3,6,7) in case we want to debug this i=
n
>> the future.
>
> Nick, are you ok with taking this patch as-is and adding the other st=
uff
> in later? =C2=A0It does fix a warning in mac80211 for unknown rates a=
nd
> instead warns with the actual hw rate code we get.
>

Sure ;-)


--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
