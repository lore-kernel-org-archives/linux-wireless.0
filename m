Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from psyche.uwaterloo.ca ([129.97.128.244]:46140 "EHLO
        psyche.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752469AbeBLTKo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Feb 2018 14:10:44 -0500
Received: from [129.97.168.8] (scspc527.cs.uwaterloo.ca [129.97.168.8])
        (authenticated bits=0)
        by psyche.uwaterloo.ca (8.14.4/8.14.4) with ESMTP id w1CJ5aBF027816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-wireless@vger.kernel.org>; Mon, 12 Feb 2018 14:05:36 -0500
To: linux-wireless@vger.kernel.org
From: Ali Abedi <a2abedi@uwaterloo.ca>
Subject: 802.11ac devices that use Minstrel_HT
Message-ID: <769da6f9-bca3-48bd-32e6-009dd82f3c96@mailservices.uwaterloo.ca> (sfid-20180212_201047_605760_87658E85)
Date: Mon, 12 Feb 2018 14:05:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

It seems that Minstrel_ht rate adaptation algorithm supports 802.11ac 
VHT rates.
Can you refer me to some 802.11ac devices that use this rate adaptation 
algorithm?
I need to modify the rate adaptation algorithm however all 802.11ac 
devices that I know have moved this functionality to (closed) firmware.

Best,
Ali
