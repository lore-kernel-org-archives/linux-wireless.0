Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35489 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753314AbdCOM2s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 08:28:48 -0400
Received: by mail-io0-f195.google.com with SMTP id f103so2797117ioi.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Mar 2017 05:28:47 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: ANNOUNCE: New Talk: Story of a Network Virtualization and it's future
 in Software and in Hardware
To: people@netdevconf.org
Cc: tech-committee@netdevconf.org, netfilter-devel@vger.kernel.org,
        Brenda Butler <bjb@mojatatu.com>,
        Stephen Jaworski <jaws@mojatatu.com>,
        netfilter@vger.kernel.org, linux-wireless@vger.kernel.org,
        Heri Muhero <hmuhero@gmail.com>
Message-ID: <a08ffed4-7ae7-68c3-4ebb-296346241469@mojatatu.com> (sfid-20170315_133037_355840_50CF2689)
Date: Wed, 15 Mar 2017 08:28:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tech committee would like to announce a new accepted talk from
Anjali Singhai Jain along with
Alexander H Duyck, Parthasarathy Sarangam and Nrupal Jani

The details are as follows:
-------
The paper and the presentation will quickly go through a time lapse of 
Network virtualization as it evolved, successes and failures and the 
reasons behind those. Revisiting history and understanding the present 
and future use cases for Network virtualization will fuel the future 
Hardware and Software designs for a better end user experience and 
pushing the envelope on Network virtualization. Intel and the industry 
has seen many generations of Network virtualization.

The talk will be focused on two important areas:

     Briefly Analyze the past and present
     Make a case for the future technologies

The talk will go deep dive into HW challenges in two areas of Network 
Virtualization:

     Why the Hardware offloads and getting them just right is important 
(Goldilocks effect), may be SRIOV is little too much.
     Host interface exposed by a network Virtualization device and how 
do we get that just right

The talk will also cover what the future SW model for Network 
Virtualization is shaping up to be

     The best control and data plane split that works for Network or 
compute intensive VMs/Containers.
     Why less is more in some cases for the Virtual function device.
     Is true SR-IOV a good answer in all cases, are Mediated devices a 
better compromise

To conclude we will go over the upcoming Virtualization technology 
supported by VFIO Mediated devices and PCIE specification for PASID, 
what problems will that solve. How do we get the software model right in 
this case and learn from our mistakes with SR-IOV.
----

cheers,
jamal
