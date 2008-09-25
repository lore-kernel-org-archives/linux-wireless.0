Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:19473 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbYIYVg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 17:36:27 -0400
Received: by fk-out-0910.google.com with SMTP id 18so592825fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 14:36:26 -0700 (PDT)
Message-ID: <1ba2fa240809251436j500e1435ldf165b43451aa628@mail.gmail.com> (sfid-20080925_233631_832168_61576470)
Date: Fri, 26 Sep 2008 00:36:25 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
Cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48DC0008.2070802@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48DBE5E8.2000507@hauke-m.de> <48DC0008.2070802@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2008 at 12:18 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> Hauke Mehrtens wrote:
>> After upgrading from wireless-testing-2008-09-12 to
>> wireless-testing-2008-09-24 I got the following kernel panic short after
>> starting linux.
>>
>> It happens at every start. After starting an older linux version
>> everything works as it should.
>>
>> I think it happens in the connecting process.
>>
>> I am using Ubuntu Hardy with network manager 0.7
>> I have got an rtl8187 chip on my Asus P5B Deluxe wifi.
>
> I can confirm this with and without my RTL8187B inserted.
>
> Larry
>
wild guess try to revert:
'mac80211: make master iface not wireless'

Tomas
