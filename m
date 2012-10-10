Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64700 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab2JJPTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 11:19:49 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so600751oag.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2012 08:19:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121010001024.GE22517@ritirata.org>
References: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
	<20581.2614.43943.601901@gargle.gargle.HOWL>
	<50652E56.10303@qca.qualcomm.com>
	<20581.32544.134606.56158@gargle.gargle.HOWL>
	<20120929093118.GA3022@ritirata.org>
	<CAD2nsn20s3L8b8DT53JYAN-t4q5GpxUVzSCncTt1LQO3w=wsYw@mail.gmail.com>
	<20121010001024.GE22517@ritirata.org>
Date: Wed, 10 Oct 2012 20:49:48 +0530
Message-ID: <CAD2nsn11fihMnzryTJzRBqbR86FcT6cA8WWtFBvQxgzeWMUmEA@mail.gmail.com> (sfid-20121010_172007_763001_221DBFDC)
Subject: Re: [RFC 1/2] ath9k_htc: Advertize allowed vif combinations
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: Sujith Manoharan <c_manoha@qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Antonio,

>
> Hi Mohammed,
>
> thank you for having taken care of this. Is it possible to have more details
> about this "impossibility"? I still have to understand, because on one side we
> all agreed on the fact that IBSS+AP coexistence will create problems on the STA
> (connected to the AP) because of the TSF jumps, but this would still "work". On
> the other side the maintainer is claiming this would not work at all :-) At this
> point, I'd like to clearly understand "why" he is claiming so: is it for the
> same reason explained above (TSF jumps) or is there something else?

completely agree with your point, but one thing I am not sure about is
there something
specific with ath9k_htc firmware/ h/w code limitations(beacon.c). I
need to take a close
look at this. I will just check again with the ath9k_htc maintainer(if
I can reach him !).
But if you had tested this better please go ahead and send the patch,
as it wouldn't be
breaking. Since the maintainer himself has better understanding about
ath9k_htc(also its firmware)
he certainly might have a better reason to say so. Certainly ath9k_htc
has some limitations
in firmware and some know issues too!.

I have limited time as i am working in some other project!

>
> Cheers,
>
>
> --
> Antonio Quartulli
>
> ..each of us alone is worth nothing..
> Ernesto "Che" Guevara



-- 
thanks,
shafi
