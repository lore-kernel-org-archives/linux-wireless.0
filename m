Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40219 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2JHPuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 11:50:39 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so3665957obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2012 08:50:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120929093118.GA3022@ritirata.org>
References: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
	<20581.2614.43943.601901@gargle.gargle.HOWL>
	<50652E56.10303@qca.qualcomm.com>
	<20581.32544.134606.56158@gargle.gargle.HOWL>
	<20120929093118.GA3022@ritirata.org>
Date: Mon, 8 Oct 2012 21:20:38 +0530
Message-ID: <CAD2nsn20s3L8b8DT53JYAN-t4q5GpxUVzSCncTt1LQO3w=wsYw@mail.gmail.com> (sfid-20121008_175042_823367_EE16C8B7)
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

On Sat, Sep 29, 2012 at 3:01 PM, Antonio Quartulli <ordex@autistici.org> wrote:
> On Fri, Sep 28, 2012 at 04:12:40 +0530, Sujith Manoharan wrote:
>> Mohammed Shafi Shajakhan wrote:
>> > oh yeah, you are saying that we will have some issues with IBSS
>> > coexistence with other modes because of TSF sync.
>>
>> Yes, this is a problem.
>
> Is there anyway to overcome this problem? Can we bind the single TSF to multiple
> virtualTSF? or must the device somehow support us?

Antonio, agained i checked with the ath9k_htc maintainer, he said the
IBSS coexistence is not
possible. So i would go with my current patch. Please do feel free to
enhance. Currently
i am working in some other project, not sure i would be able to take this up.

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
