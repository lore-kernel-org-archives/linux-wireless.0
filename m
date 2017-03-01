Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:9602 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdCAOqG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 09:46:06 -0500
Subject: Re: [PATCH 2/2][RFC] mac80211_hwsim: Report radio addresses in
 NEW_RADIO/GET_RADIO
To: Ben Greear <greearb@candelatech.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>
References: <20170223120211.22358-1-andrew.zaborowski@intel.com>
 <20170223120211.22358-2-andrew.zaborowski@intel.com>
 <1488202062.28431.7.camel@sipsolutions.net>
 <CAOq732JzrGxFUa5BiuO=Sz7gscRV7PFxOOyy1xf6mtmQfUqkaA@mail.gmail.com>
 <2155efb0-1325-0089-fbb1-cc63cc289745@candelatech.com>
 <CAOq732+MZt=mytXrZko0uw=EsBWvQpZ49wg3CxFPVn0uGGNyog@mail.gmail.com>
 <4549b209-df6c-0eaa-65e6-72562c61bf4b@candelatech.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <4efcd470-86ee-2f3d-bbe2-1d82874edffd@uni-rostock.de> (sfid-20170301_154637_987641_A08F2FE7)
Date: Wed, 1 Mar 2017 15:33:55 +0100
MIME-Version: 1.0
In-Reply-To: <4549b209-df6c-0eaa-65e6-72562c61bf4b@candelatech.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> You can specify the MAC address and name (ie, wiphy0) when creating a
> hwsim radio.
> You cannot specify the index.  So, from a user-space perspective,
> I think the name and MAC is more important than the index.
>
That is actually not possible. The permanent MAC-Addresses of hwsim
radios are directly created by there internal ID, which is only
increased for new radios and definitely not reassigned. 

But I would be happy, if this were possible, since it would make some
simulation related stuff easier (currently we need to unload and load
the hwsim module over and over again for every run).



-- 
M.Sc. Benjamin Beichler

Universität Rostock, Fakultät für Informatik und Elektrotechnik
Institut für Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Straße 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/
