Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40906 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727Ab2FNPSL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 11:18:11 -0400
Received: by lahd3 with SMTP id d3so1333096lah.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 08:18:09 -0700 (PDT)
Message-ID: <4FDA00A2.8020800@googlemail.com> (sfid-20120614_171828_525466_A9D42E45)
Date: Thu, 14 Jun 2012 16:17:54 +0100
From: Michael Zintakis <michael.zintakis@googlemail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	Jean-Pierre TOSONI <jp.tosoni@acksys.fr>,
	linux-wireless@vger.kernel.org
Subject: Re: Is there a changelog for compat wireless ?
References: <773DB8A82AB6A046AE0195C68612A319012CA16F@sbs2003.acksys.local> <4FC6A68D.1010002@hauke-m.de> <CAB=NE6UxQ=w3shKs8pWRYsjPpTdMAN4Vs=a9jwkHsfTe-WVVDQ@mail.gmail.com>
In-Reply-To: <CAB=NE6UxQ=w3shKs8pWRYsjPpTdMAN4Vs=a9jwkHsfTe-WVVDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> The changelog for compat-wireless is here:
>> https://github.com/mcgrof/compat-wireless/commits/master
>> for compat here:
>> https://github.com/mcgrof/compat/commits/master
>> and for wireless-testing here:
>> https://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=shortlog
>>     
>
> And then we have unified changelogs for stable releases these are
> listed on the stable page:
>
> http://wireless.kernel.org/en/users/Download/stable/
>
> For example:
>
> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.4/ChangeLog-3.4-rc3
>   
According to grep I've run on all available Changelogs, the only driver 
which appears to support .11w is ath9k. Is there any other driver which 
currently has this support? What about ath9k_usb?

